# flutter_icon_font_package_template

This package provides a template for creating font icon packs for Flutter from
SVG source.

## Getting Started

1. Click "Use this template"
2. Change the package details in [`pubspec.yaml`](./pubspec.yaml): name, author,
   description, homepage
3. Replace [`assets/fonts/CustomFont.svg`](./assets/fonts/CustomFont.svg) with
   your own SVG font, e.g. `MyFont.svg`
   - You will want the name to be in PascalCase
   - You can use [Inkscape](https://inkscape.org/) to create SVG fonts:
     1. Create a new file from the Typography Canvas template
     2. Place your glyphs on layers created with Extensions > Typography > Add
        Glyph Layer
     3. Do Extensions > Typography > Convert Glyph Layers to SVG Font
4. Replace [`assets/fonts/CustomFont.yaml`](./assets/Fonts/CustomFont.yaml) with
   e.g. `MyFont.yaml`, a map giving human-readable names to the codepoints
   covered by your font. Names must be valid Dart identifiers.
5. Run `make` from the root to generate the TTFs and icon data classes
   - `npm` must be installed in order to generate the TTFs
6. Edit the `fonts:` section in `pubspec.yaml` to replace `CustomFont` with your
   font
7. Add the package as a dependency to your consuming project

You can then create icons like `Icon(MyFontIcons.foo)`.

## Icon Font vs SVG

The example app serves as a performance comparison between icon fonts and SVG
icons. In my testing, the icon font performs much better than SVG in debug
builds, but in release builds the difference is not noticeable.

## Acknowledgments

The sample font uses a glyph from [Evil Icons](https://evil-icons.io/); see
[LICENSE](./LICENSE.txt).
