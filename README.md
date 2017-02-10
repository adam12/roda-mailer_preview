# Roda Mailer Preview

Easily preview your emails inside your application under a customizable route.

If you've ever used the `mail_view` gem for Rails, or in recent Rails versions,
the ability to preview an email, this is very similar to that.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "roda-mailer_preview"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roda-mailer_preview

## Usage

Aside from configuring the Roda mailer plugin as you normally would, routes to preview the emails
is required, ensuring that the `preview` or `preview_index` methods are called with an instance of
a `Mail` object.

```ruby
class App < Roda
  plugin :mailer_preview

  route do |r|
    r.on "mail_view" do
      # Preview /the-mailer at /mail_view/test
      r.is "test" do
        mail = YourMailer.mail("/the-mailer")
        preview(mail)
      end

      # Provides an index of all previewable-mailers at /mail_view
      r.is true do
        mailers = ["/test"]
        preview_index(mailers)
      end
    end
  end
end
```

## Gotchas

This library doesn't currently support HTML views. I'd likely accept a pull request if you wanted to
submit one.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adam12/roda-mailer_preview.

I love pull requests! If you fork this project and modify it, please ping me to see
if your changes can be incorporated back into this project.

That said, if your feature idea is nontrivial, you should probably open an issue to
[discuss it](http://www.igvita.com/2011/12/19/dont-push-your-pull-requests/)
before attempting a pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Credits

I was shamelessly inspired by the CSS of the MailView gem.
