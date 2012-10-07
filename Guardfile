notification  :tmux,
              :success => 'colour22',
              :failed  => 'colour52',
              :display_message => true

guard 'rspec',
      all_on_start:   true,
      all_after_pass: true,
      cli:            '--format Fuubar',
      notification:   true do

  watch(%r{^(spec\/.+_spec\.rb)$})   { |m| m[1] }
  watch(%r{^lib/dolla_dolla_bill\.rb$})      { |m| "spec/dolla_dolla_bill_spec.rb" }
  watch(%r{^lib/dolla_dolla_bill/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
