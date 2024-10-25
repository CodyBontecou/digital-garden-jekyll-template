# _plugins/image_carousel_converter.rb
require 'nokogiri'

module Jekyll
  class ImageCarouselConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      doc = Nokogiri::HTML::DocumentFragment.parse(content)
      current_group = []

      doc.children.each_with_index do |node, index|
        if node.name == 'p'
          # Check if paragraph contains only images
          images = node.css('img')
          if images.length > 0 && images.length == node.children.length
            images.each { |img| current_group << img }
            node.remove
          else
            process_current_group(current_group, node)
            current_group = []
          end
        else
          process_current_group(current_group, node)
          current_group = []
        end
      end

      # Handle any remaining images at the end
      process_current_group(current_group, nil) if current_group.any?

      doc.to_html
    end

    private

    def process_current_group(images, node)
      return unless images.any?

      if images.length == 1
        # For single images, just reinsert them normally
        img_html = "<p>#{images.first.to_html}</p>"
        if node
          node.add_previous_sibling(Nokogiri::HTML::DocumentFragment.parse(img_html))
        else
          doc.add_child(Nokogiri::HTML::DocumentFragment.parse(img_html))
        end
      else
        # For multiple images, create a carousel
        carousel = create_carousel(images)
        if node
          node.add_previous_sibling(carousel)
        else
          doc.add_child(carousel)
        end
      end
    end

    def create_carousel(images)
      carousel_html = <<-HTML
        <div class="image-carousel">
          <div class="carousel-inner">
      HTML

      images.each_with_index do |img, index|
        active_class = index == 0 ? ' active' : ''
        carousel_html += <<-HTML
            <div class="carousel-item#{active_class}">
              <img src="#{img['src']}" alt="#{img['alt']}" loading="lazy">
            </div>
        HTML
      end

      carousel_html += <<-HTML
          </div>
          <button class="carousel-prev" aria-label="Previous slide">❮</button>
          <button class="carousel-next" aria-label="Next slide">❯</button>
        </div>
      HTML

      Nokogiri::HTML::DocumentFragment.parse(carousel_html)
    end
  end
end
