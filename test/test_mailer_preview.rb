require "minitest/autorun"
require "rack/test"
require "roda"

class TestMailerPreview < Minitest::Test
  include Rack::Test::Methods

  def app
    Class.new(Roda) do
      plugin :render
      plugin :mailer
      plugin :mailer_preview

      route do |r|
        r.mail "test" do
          from    "test@example.com"
          to      "test@example.com"
          subject "Test Email"
          render  inline: "Test email body"
        end

        r.mail "multipart" do
          from      "text@example.com"
          to        "test@example.com"
          subject   "Test Email"
          text_part "Test email"
          html_part "<span>HTML Part</span>"
        end

        r.on "mail_view" do
          r.is "test" do
            mail = self.class.mail("/test")
            preview(mail)
          end

          r.is "multipart" do
            mail = self.class.mail("/multipart")
            preview(mail)
          end

          r.is true do
            preview_index(["/test"])
          end
        end
      end
    end
  end

  def test_preview_email
    get "/mail_view/test"

    assert last_response.ok?
    assert_match %r{Test Email}, last_response.body
    assert_match %r{Test email body}, last_response.body
  end

  def test_multipart_preview
    get "/mail_view/multipart"
    assert last_response.ok?
    assert_match %r{HTML Part}, last_response.body
  end

  def test_preview_index
    get "/mail_view"

    assert last_response.ok?
    assert_match %r{/test}, last_response.body
  end

end
