mail_packages:
  pkg.installed:
    - names:
      - postfix

postfix.service:
  service.running:
    - enable: True