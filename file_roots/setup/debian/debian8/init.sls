{% set os_codename = 'jessie' %}
{% set prefs_text = 'Package: python-alabaster
        Pin: release a=testing
        Pin-Priority: 950
        Package: libjs-sphinxdoc
        Pin: release a=testing
        Pin-Priority: 940 
        Package: sphinx-common
        Pin: release a=testing
        Pin-Priority: 930 
        Package: python-sphinx
        Pin: release a=testing
        Pin-Priority: 920
        Package: *
        Pin: release a=' ~ os_codename ~ '-backports
        Pin-Priority: 750
        Package: *
        Pin: release a=stable
        Pin-Priority: 700
        Package: *
        Pin: release a=testing
        Pin-Priority: 650
        Package: *
        Pin: release a=unstable
        Pin-Priority: 600
        Package: *
        Pin: release a=experimental
        Pin-Priority: 550
' %}

include:
  - setup.debian

build_pbldhooks_file:
  file.append:
    - name: /root/.pbuilder-hooks/G05apt-preferences
    - makedirs: True
    - text: |
        #!/bin/sh
        set -e
        cat > "/etc/apt/preferences" << EOF
        {{prefs_text}}
        EOF
    

build_pbldhooks_perms:
  file.directory:
    - name: /root/.pbuilder-hooks/
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755
    - recurse:
        - user
        - group
        - mode


build_pbldrc:
  file.append:
    - name: /root/.pbuilderrc
    - text: |
        DIST="{{os_codename}}"
        if [ -n "${DIST}" ]; then
          TMPDIR=/tmp
          BASETGZ="`dirname $BASETGZ`/${DIST}-base.tgz"
          DISTRIBUTION=${DIST}
          APTCACHE="/var/cache/pbuilder/${DIST}/aptcache"
        fi
        HOOKDIR="${HOME}/.pbuilder-hooks"
        OTHERMIRROR="deb http://ftp.us.debian.org/debian/ stable  main contrib non-free | deb http://ftp.us.debian.org/debian/ testing main contrib non-free | deb http://ftp.us.debian.org/debian/ unstable main contrib non-free"
        

build_prefs:
  file.append:
    - name: /etc/apt/preferences
    - text: |
        {{prefs_text}}

