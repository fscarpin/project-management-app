module ApplicationHelper
  ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      tag_class = options.extract!(:class)[:class]
      tag_options = {
        class: "alert fade in alert-#{type} #{tag_class}"
      }.merge(options)

      close_button = content_tag(:button, raw("&times;"), type: "button", class: "close", "data-dismiss" => "alert")

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg, tag_options)
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  # Returns true if any of the given models have any errors
  def models_have_any_error? (models)
    has_errors = false

    models.each do |m|
      if m
        has_errors = true if m.errors.any?
      end
    end

    return has_errors
  end

  # Returns an errors array with all the erros for the given models
  def errors_from_models (models)
    errors = []

    models.each do |model|
      if model && model.errors.any?
        errors += model.errors.full_messages
      end
    end

    return errors
  end

  # Returns the tenant name for the given tenant_id
  def tenant_name(tenant_id)
    return Tenant.find(tenant_id).name
  end

  # Returns the tenant plan for the given tenant_id
  def tenant_plan(tenant_id)
    return Tenant.find(tenant_id).plan
  end
end
