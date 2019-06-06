from __future__ import print_function
import sys
import os
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
    "  static const IconData u%(code_point)X = IconData("
    "0x%(code_point)X, "
    "fontFamily: '%(font_name)s', "
    "fontPackage: '%(package_name)s'"
    ");"
)


def gen_class(svg_file, class_name, font_name, package_name):
    svg = ElementTree.parse(svg_file)
    glyph_chars = [glyph.get('unicode') for glyph
                   in svg.iterfind('.//svg:glyph[@unicode]', namespaces=ns)]
    props = [prop_template % {'code_point': ord(c),
                              'font_name': font_name,
                              'package_name': package_name}
             for c in glyph_chars]
    gen_class = class_template % {
        'class_name': class_name, 'properties': '\n'.join(props)}
    return gen_class


def die():
    print('usage: %s svg packagename' % sys.argv[0], file=sys.stderr)
    sys.exit(1)


def main():
    args = sys.argv[1:]
    if len(args) != 2:
        die()
    if not os.path.isfile(args[0]):
        die()
    svg_file, package_name = args
    filename = os.path.basename(svg_file)
    font_name, _ = os.path.splitext(filename)
    class_name = font_name + 'Icons'
    result = gen_class(svg_file, class_name, font_name, package_name)
    print(result)


if __name__ == '__main__':
    main()
