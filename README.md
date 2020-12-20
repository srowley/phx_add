# Phx.Add

A simple example of how composable custom Phoenix generators might work for discussion
purposes. Tested in the sense that I followed the instructions and I could use Tailwind
and Alpine in the app afterwards.

## Installation

Install locally with `mix archive.install github srowley/phx_add`.

## Usage

```
mix phx.new my_app --live
cd my_app
mix phx.add.tailwind
mix phx.add.alpine
```

Note that the Alpine generator assumes the new app is a Live View app; it would be easy
to fix so that it worked for a regular app.