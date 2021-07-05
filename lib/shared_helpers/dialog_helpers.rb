module SharedHelpers
  module DialogHelpers
    def discard_dialog(id:, title: 'Discard unsaved changes?', body: nil)
      cancel_button_id = "#{id}_cancel_button"
      discard_button_id = "#{id}_discard_button"

      dialog id: id do
        title title
        body body if body.present?
        actions do
          button :discard, id: discard_button_id
          button :cancel, type: :raised, id: cancel_button_id
        end
      end
    end

    def delete_dialog(id:,
                      record_name:,
                      delete_path:,
                      load_path: nil, # pass either a load_path or a block
                      details: nil,
                      &block)
      dialog id: id do
        title t(:delete_confirm, 'Are you sure you want to delete %{record}?', record: record_name), markdown: false
        body details unless details.nil?

        actions do
          button t(:cancel)
          button t(:delete), type: :raised do
            event :click do
              deletes delete_path unless delete_path.nil?
              if block_given?
                yield_to(&block)
              else
                loads load_path
              end
            end
          end
        end
      end
    end

    alias yielding_delete_dialog delete_dialog

    def confirm_dialog(id:,
                       title: nil,
                       button_text:,
                       details: nil,
                       &block)
      dialog id: id do
        title title, markdown: false
        body details unless details.nil?

        actions do
          button t(:cancel)
          button button_text, type: :raised do
            event :click do
              yield_to(&block)
            end
          end
        end
      end
    end

    def message_dialog(id:, message:, title: nil, button_text: nil)
      dialog id: id do
        title title, markdown: false if title
        body message

        actions do
          button button_text || t(:ok), type: :raised
        end
      end
    end

  end
end
