# EnigmaMachine

This is a simulator for an [Enigma Machine](http://en.wikipedia.org/wiki/Enigma_machine). It currently simulates both the Enigma I/M3 and the Enigma M4. It also allows for specifying your own custom rotor/reflector configurations.

## Installation

Add this line to your application's Gemfile:

    gem 'enigma_machine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enigma_machine

## Usage

    e = EnigmaMachine.new(
      :reflector => :B,
      :rotors => [[:i, 10], [:ii, 14], [:iii, 21]],
      :plug_pairs => %w(AP BR CM FZ GJ IL NT OV QS WX)
    )
    e.set_rotors('V', 'Q', 'Q')
    
    result = e.translate('HABHV HLYDF NADZY')

See `integration_spec.rb` for some more examples

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
