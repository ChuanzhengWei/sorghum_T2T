#!/usr/bin/env python
# coding: utf-8

# In[8]:


def hex_to_rgb(hex_color):
    return tuple(int(hex_color[i:i+2], 16) for i in (1, 3, 5))

def rgb_to_hex(rgb_color):
    return '#' + ''.join(f'{c:02X}' for c in rgb_color)

def find_mid_color(hex_color1, hex_color2):
    rgb1 = hex_to_rgb(hex_color1)
    rgb2 = hex_to_rgb(hex_color2)
    
    mid_rgb = tuple((c1 + c2) // 2 for c1, c2 in zip(rgb1, rgb2))

    return rgb_to_hex(mid_rgb)

# In[10]:


tmp = ['#1A237E','#4874CB','#00695C','#0097A7 ','#558B2F','#6A1B9A','#D32F2F','#F57C00','#EE822F','#F9A825']


# In[13]:


for i in tmp:
    print(find_mid_color(i, '#FFFFFF'))

