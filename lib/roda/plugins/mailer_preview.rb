require "roda"

class Roda
  module RodaPlugins
    module MailerPreview
      TEMPLATE = <<-EOC
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

      INDEX_TEMPLATE = <<-EOC
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
        def preview(mail)
          acceptable_headers = %w(Date From To Subject)

          headers = mail.header_fields.select do |field|
            acceptable_headers.include?(field.name)
          end

          render(inline: TEMPLATE, locals: { mail: mail, headers: headers })
        end

        def preview_index(urls, path: request.path)
          render(inline: INDEX_TEMPLATE, locals: { urls: urls, path: path })
        end
      end

      def self.load_dependencies(app, opts = {})
        app.plugin :render
      end
    end

    register_plugin :mailer_preview, MailerPreview
  end
end
