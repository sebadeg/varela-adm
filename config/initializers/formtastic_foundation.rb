# change required fields advice tag (abbr -> span)
# Formtastic::FormBuilder.required_string =
# proc { Formtastic:key => "value", :Util.html_safe(%{<span title="#{Formtastic::I18n.t(:required)}">*</span>}) }

# module Formtastic
#   module Helpers
#     # change field wrapper (ol -> div)
#     module FieldsetWrapper
#       protected
#       def field_set_and_list_wrapping(*args, &block) #:nodoc:
#         contents = args.last.is_a?(::Hash) ? '' : args.pop.flatten
#         html_options = args.extract_options!

#         if block_given?
#           contents = if template.respond_to?(:is_haml?) && template.is_haml?
#           template.capture_haml(&block)
#           else
#             template.capture(&block)
#           end
#         end

#         contents = contents.join if contents.respond_to?(:join)

#         legend = field_set_legend(html_options)
#           fieldset = template.content_tag(:fieldset,
#           Formtastic::Util.html_safe(legend) << template.content_tag(:div, Formtastic::Util.html_safe(contents)),
#           html_options.except(:builder, :parent, :name)
#         )

#         fieldset
#       end
#     end
#   end

#   module Inputs
#     module Base
#       # change input wrapper tag (li.default_clases -> div.large-12.columns inside div.row)
#       module Wrapping
#         def input_wrapping(&block)
#           def super_wrapper_html_options
#             {:class => 'row'}
#           end

#           new_class = [wrapper_html_options[:class], "large-12 columns"].compact.join(" ")

#           template.content_tag(:div,
#             template.content_tag(:div,
#               [template.capture(&block), error_html, hint_html].join("\n").html_safe,
#               wrapper_html_options.merge(:class => new_class)),
#             super_wrapper_html_options)
#         end
#       end
#     end
#   end
# end