# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js', preload: true

# pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
# pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
# pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
# pin "trix"
# pin "@rails/actiontext", to: "actiontext.js"
