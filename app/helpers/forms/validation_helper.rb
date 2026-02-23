# frozen_string_literal: true

module Forms
  # Helper module to render styled form fields with built-in validation support
  module ValidationHelper
    # Render a text input field with validation styling and feedback
    def validated_input(form, field_name, options = {})
      label_text = options.delete(:label)
      placeholder = options.delete(:placeholder)
      css_class = options.delete(:css_class) || "w-full bg-slate-800/50 border border-slate-600/50 rounded-lg px-4 py-3 text-slate-100 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition"

      content_tag(:div, class: "space-y-2") do
        if label_text
          form.label field_name, label_text, class: "block text-sm font-semibold text-slate-200"
        end +
        form.text_field(field_name, options.merge(
          class: css_class,
          placeholder: placeholder,
          data: { validation_field: field_name }
        )) +
        content_tag(:div, "", id: "#{form.object_name}_#{field_name}-feedback", class: "mt-1 text-sm")
      end
    end

    # Render a textarea field with validation styling and feedback
    def validated_textarea(form, field_name, options = {})
      label_text = options.delete(:label)
      placeholder = options.delete(:placeholder)
      rows = options.delete(:rows) || 5
      css_class = options.delete(:css_class) || "w-full bg-slate-800/50 border border-slate-600/50 rounded-lg px-4 py-3 text-slate-100 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition"

      content_tag(:div, class: "space-y-2") do
        if label_text
          form.label field_name, label_text, class: "block text-sm font-semibold text-slate-200"
        end +
        form.text_area(field_name, options.merge(
          class: css_class,
          placeholder: placeholder,
          rows: rows,
          data: { validation_field: field_name }
        )) +
        content_tag(:div, "", id: "#{form.object_name}_#{field_name}-feedback", class: "mt-1 text-sm")
      end
    end

    # Render an email input field with validation
    def validated_email_input(form, field_name = :email, options = {})
      validated_input(form, field_name, options.merge(label: "Email", placeholder: "you@example.com"))
    end

    # Render a password input field with validation
    def validated_password_input(form, field_name = :password, options = {})
      label_text = options.delete(:label) || "Password"
      placeholder = options.delete(:placeholder) || "At least 8 characters, with letters, numbers, and symbols"
      css_class = options.delete(:css_class) || "w-full bg-slate-800/50 border border-slate-600/50 rounded-lg px-4 py-3 text-slate-100 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition"

      content_tag(:div, class: "space-y-2") do
        form.label field_name, label_text, class: "block text-sm font-semibold text-slate-200" +
        form.password_field(field_name, options.merge(
          class: css_class,
          placeholder: placeholder,
          data: { validation_field: field_name }
        )) +
        content_tag(:div, "", id: "#{form.object_name}_#{field_name}-feedback", class: "mt-1 text-sm")
      end
    end
  end
end
