ActionMailer::Base.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "gmail.com",
    user_name: "brownie3003",
    password: ENV['GMAIL_PW'],
    authentication: "plain",
    enable_starttls_auto: true
}

ActionMailer::Base.default_url_options[:host] = "pocket-social.com"
