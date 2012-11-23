mail_packages:
  pkg.installed:
    - names:
      - postfix

postfix:
  service.running:
    - enable: True
    - require:
      - pkg: postfix
