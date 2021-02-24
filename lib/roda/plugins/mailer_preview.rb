# frozen-string-literal: true

require "roda"

class Roda
  module RodaPlugins
    # The +mailer_preview+ plugin provides an HTML representation of the email
    # without requiring it to be delivered through SMTP.
    #
    #   plugin :mailer_preview
    #
    # = Preview email
    #
    # To preview an email, create a route which finishes by calling {InstanceMethods#preview}
    # with an instance of a Mail object.
    #
    #   r.on "previews" do
    #     r.is "signup-email" do
    #       mail = YourMailer.mail("/signup-email")
    #       preview(mail)
    #     end
    #   end
    #
    # = Preview index
    #
    # For a single point of entry to all your mail previews, provide an array
    # of paths to {InstanceMethods#preview_index}
    #
    #   r.is "previews" do
    #     available_previews = ["/previews/signup-email"]
    #     preview_index(available_previews)
    #   end
    module MailerPreview
      module InstanceMethods
        # Pass an instance of +Mail::Message+ to render a preview
        #
        # @example
        #   r.on "previews" do
        #     r.is "signup-email" do
        #       mail = YourMailer.mail("/signup-email")
        #       preview(mail)
        #     end
        #   end
        def preview(mail)
          acceptable_headers = %w(Date From To Subject)

          headers = mail.header_fields.select do |field|
            acceptable_headers.include?(field.name)
          end

          render(path: __dir__ + "/preview.erb", locals: { mail: mail, headers: headers })
        end

        # Pass an array of paths to render an index of available previews
        #
        # @example
        #   r.is "previews" do
        #     available_previews = ["/previews/signup-email"]
        #     preview_index(available_previews)
        #   end
        def preview_index(urls, path: request.path)
          render(path: __dir__ + "/index.erb", locals: { urls: Array(urls), path: path })
        end
      end

      # @api private
      def self.load_dependencies(app, opts = {})
        app.plugin :render
      end
    end

    register_plugin :mailer_preview, MailerPreview
  end
end
