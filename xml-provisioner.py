#!/usr/bin/env python

import xml.etree.ElementTree as ET
tree = ET.parse('master.xml')
root = tree.getroot()

#print root.tag
#print root.attrib

#for child in root:
#       print child.tag, child.attrib

for node in tree.findall('.//devices'):
	name=node.find('emulator').text
	print name
	for subnode in root.getiterator('mac'):
		print subnode.attrib
