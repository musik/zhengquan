module SnipsHelper
  def snip_get name
    RedCloth.new(Snip.output(name)).to_html.gsub("<a ","<a target=\"_blank\" ").html_safe rescue ""
  end
end
