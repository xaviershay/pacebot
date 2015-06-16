require 'xspec'

extend XSpec.dsl

require 'pacebot'

R = Pacebot::Response

module OpalHelper
  def self.with_opal
    yield if enabled?
  end

  def self.eval(src)
    @context ||= begin
      require 'opal'
      require 'execjs'

      builder = Opal::Builder.new
      builder.build 'opal'

      # Any lib should be already required in the page,
      # require won't work in this kind of templates.
      builder.build 'native'

      context = ExecJS.compile builder.to_s
      context
    end
    @src ||= File.read(File.expand_path("../../lib/pacebot.rb", __FILE__))
    @src += "\n"
    @src += <<-EOS
      # Struct monkey patches necessary to support round-tripping through Opal
      # for testing purposes.
      class Struct
        def ==(other)
          other.class == self.class && to_a == other.to_a
        end
      end
    EOS

    @context
      .eval(Opal.compile(@src + ";" + src)
      .gsub!(/;\s*\Z/, ''))
  end

  def self.enabled?
    !ENV['NO_OPAL']
  end
end

if OpalHelper.enabled?
  class Struct
    def to_ruby
      self.class.name + ".new(#{to_a.map(&:inspect).join(',')})"
    end
  end
end
