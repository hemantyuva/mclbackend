Rails.configuration.stripe = {
  :publishable_key => 'pk_test_47fH4h71oll6QQz1FEUtstYZ',
  :secret_key      => 'sk_test_5XvRw6SFSLzH31JEDsNZawxg'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]