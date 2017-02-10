Gem::Specification.new do |spec|
  spec.name           = "roda-mailer_preview"
  spec.version        = "0.1.0"
  spec.authors        = ["Adam Daniels"]
  spec.email          = "adam@mediadrive.ca"

  spec.summary        = %q(Preview your Roda mailer plugin emails)
  spec.description    = <<-EOM
  Easily preview your emails inside your application under a customizable route.

  If you've ever used the mail_view gem for Rails, or in recent Rails versions,
  the ability to preview an email, this is very similar to that.
  EOM

  spec.homepage       = "https://github.com/adam12/roda-mailer_preview"
  spec.license        = "MIT"

  spec.files          = ["README.md", "Rakefile"] + Dir["lib/**/*.rb"]
  spec.require_paths  = ["lib"]

  spec.add_dependency "roda", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "tilt", "~> 2.0"
  spec.add_development_dependency "mail", "~> 2.6"
  spec.add_development_dependency "rubygems-tasks", "~> 0.2"
  spec.add_development_dependency "rack-test", "~> 0.6"
end
