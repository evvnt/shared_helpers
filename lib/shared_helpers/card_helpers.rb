module SharedHelpers
  module CardHelpers
    def expand_bar(show_id,
                   title: nil,
                   icon: :expand_more,
                   hides: :preview_cards,
                   readonly: false,
                   scroll_to: nil,
                   tooltip: nil,
                   tooltip_icon: :info,
                   tooltip_color: :accent7,
                   &block)
      button_id = "#{show_id}_expand_button".to_sym

      content shows_errors: false do
        headline6 title, inline: true, padding: :right if title.present?

        if tooltip.present?
          icon tooltip_icon, color: tooltip_color do
            tooltip tooltip
          end
        end

        unless readonly
          button id: button_id, icon: icon, position: %i[top right]
          event :click do
            yield_to(&block)
            hide hides
            show show_id
            scroll_to scroll_to unless scroll_to.nil?
          end
        end
      end
    end

    def collapse_bar(hide_id,
                     title: nil,
                     icon: :expand_less,
                     shows: :preview_cards,
                     scroll_to: nil,
                     tooltip: nil,
                     tooltip_icon: :info,
                     tooltip_color: :accent7,
                     &block)
      button_id = "#{hide_id}_collapse_button".to_sym

      content shows_errors: false do
        headline6 title, inline: true, padding: :right if title.present?
        if tooltip.present?
          icon tooltip_icon, color: tooltip_color do
            tooltip tooltip
          end
        end

        button id: button_id, icon: icon, position: %i[top right]
        event :click do
          yield_to(&block)
          hide hide_id
          show shows
          scroll_to scroll_to unless scroll_to.nil?
        end
      end
    end
  end
end
