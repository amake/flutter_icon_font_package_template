from __future__ import print_function
import sys
import os
import yaml
from xml.etree import ElementTree

ns_svg = 'http://www.w3.org/2000/svg'
ns_ink = 'http://www.inkscape.org/namespaces/inkscape'
ns = {'svg': ns_svg,
      'ink': ns_ink}

class_template = '''import 'package:flutter/widgets.dart';

class %(class_name)s {
  %(class_name)s._();

%(properties)s
}
'''

prop_template = (
    "  static const IconData %(glyph_name)s = IconData("
    "0x%(code_point)X, "
    "fontFamily: '%(font_name)s', "
    "fontPackage: '%(package_name)s'"
    ");"
)


def gen_class(svg_file, class_name, font_name, package_name, glyph_map):
    svg = ElementTree.parse(svg_file)
    glyph_chars = [glyph.get('unicode') for glyph
                   in svg.iterfind('.//svg:glyph[@unicode]', namespaces=ns)]
    props = [prop_template % {'code_point': ord(c),
                              'glyph_name': glyph_map[ord(c)],
                              'font_name': font_name,
                              'package_name': package_name}
             for c in glyph_chars]
    gen_code = class_template % {
        'class_name': class_name, 'properties': '\n'.join(props)}
    return gen_code


def die():
    print('usage: %s svg glyphmap packagename' % sys.argv[0], file=sys.stderr)
    sys.exit(1)


def main():
    args = sys.argv[1:]
    if len(args) != 3:
        die()
    if not all(os.path.isfile(arg) for arg in args[:-1]):
        die()
    # pylint: disable=unbalanced-tuple-unpacking
    svg_file, map_file, package_name = args
    filename = os.path.basename(svg_file)
    font_name, _ = os.path.splitext(filename)
    class_name = font_name + 'Icons'
    with open(map_file) as in_file:
        glyph_map = yaml.safe_load(in_file)['glyphs']
    result = gen_class(svg_file, class_name, font_name,
                       package_name, glyph_map)
    print(result)


if __name__ == '__main__':
    main()
