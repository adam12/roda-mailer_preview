# frozen-string-literal: true

require "roda"

class Roda
  module RodaPlugins
    # The mailer_preview plugin provides an HTML representation of the email
    # without requiring it to be delivered through SMTP.
    #
    #   plugin :mailer_preview
    #
    # = Preview email
    #
    # To preview an email, create a route which finishes by calling +preview+
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
    # of paths to +preview_index+
    #
    #   r.is "previews" do
    #     available_previews = ["/previews/signup-email"]
    #     preview_index(available_previews)
    #   end
    module MailerPreview
      TEMPLATE = <<-EOC # :nodoc:
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width">
        <style type="text/css">
          body {
            margin: 0;
          }

          header {
            font: 12px "Lucida Grande", sans-serif;
            border-bottom: 1px solid #ddd;
            padding: 0.5em;
            overflow: visible;
          }

          header dt {
            width: 80px;
            float: left;
            clear: left;
            text-align: right;
            color: #7f7f7f;
            padding: 1px;
          }

          header dd {
            margin-left: 90px;
            padding: 1px;
          }

          .plain {
            padding: 1em;
          }
        </style>
      </head>
      <body>
        <header>
          <dl>
          <% headers.each do |header| %>
            <dt><%= header.name %>:</dt>
            <dd><%= header.to_s %></dd>
          <% end %>
          </dl>
        </header>

        <div class="body">
          <% if mail.content_type =~ /plain/ %>
            <pre class="plain"><%= mail.body %></div>
          <% else %>
            <%= mail.body %>
          <% end %>
        </div>
      </body>
      </html>
      EOC

      INDEX_TEMPLATE = <<-EOC # :nodoc:
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
        <ul>
          <% urls.each do |url| %>
          <li><a href="<%= path %><%= url %>"><%= url %></a></li>
          <% end %>
        </ul>
      </body>
      EOC

      module InstanceMethods
        # Pass an instance of +Mail+ to render a preview
        #
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

          render(inline: TEMPLATE, locals: { mail: mail, headers: headers })
        end

        # Pass an array of paths to render an index of available previews
        #
        #   r.is "previews" do
        #     available_previews = ["/previews/signup-email"]
        #     preview_index(available_previews)
        #   end
        def preview_index(urls, path: request.path)
          render(inline: INDEX_TEMPLATE, locals: { urls: urls, path: path })
        end
      end

      def self.load_dependencies(app, opts = {}) # :nodoc:
        app.plugin :render
      end
    end

    register_plugin :mailer_preview, MailerPreview
  end
end
