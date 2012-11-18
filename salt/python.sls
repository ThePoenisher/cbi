#########   python-gnupg  #########
{% if grains['oscodename'] == "oneiric" %}
cd /usr/share/ && (curl http://python-gnupg.googlecode.com/files/python-gnupg-0.3.1.tar.gz | tar xz ) && cd python-gnupg-0.3.1 && python setup.py install:
  cmd.run:
    - unless:  (! command -v python) || python -c 'import gnupg'

{% endif %}