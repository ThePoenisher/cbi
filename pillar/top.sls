#pillar
base:
  '*':
    - {{ grains['cbi_machine'] }}
    - common