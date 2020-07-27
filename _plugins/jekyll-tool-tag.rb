module Jekyll
  class ToolTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      parts = @text.split('|')
      # The first part should be any text, the last should be the tool_id/tool_version
      # {% tool Group on Column %} → INVALID
      # {% tool Group on Column|Grouping1 %}
      # {% tool Group on Column|Grouping1/1.0.0 %}
      # {% tool Group on Column|toolshed.g2.bx.psu.edu/repos/devteam/fastqc/fastqc/0.72+galaxy1 %}

      if parts.length == 1
        raise SyntaxError.new(
          "No tool defined for: '#{@parts}'. "
        )
      elsif parts.length == 2
        %Q(<span class="tool" data-tool="#{parts[1]}" title="Tested with #{parts[1]}"><strong>#{parts[0]}</strong> <i class="fas fa-wrench" aria-hidden="true"></i><span class="visually-hidden">Tool: #{parts[0]}</span></span> )elsif parts.length == 3
        %Q(<span class="tool" data-tool="#{parts[1]}" title="Tested with #{parts[1]} version #{parts[2]}" data-version="#{parts[2]}"><strong>#{parts[0]}</strong> <i class="fas fa-wrench" aria-hidden="true"></i><i aria-hidden="true" class="fas fa-cog"></i></span>)
      end

    end
  end
end

Liquid::Template.register_tag('tool', Jekyll::ToolTag)
