#!/usr/bin/env python3
import yaml
import os
import os.path
import fnmatch

yaml_document = '''
ignore:
# data
- "/[!.]*"    # just normal files...
# global data
- /.ssh       # ssh keys and stuff
- /.netrc     # login passwords
- /.abuild    # Alpine building signing keys
- /.arm_prefs # Alpine (ch)root manager preferences
# User config (but I don't use...)
- /.mplayer
- /.gnupg
- /.xscreensaver
# Stuff best ignored (or sync by app itself)
- /.ssr          # Simple Screen Recorder
- /.cache        # Cache... duh!
- /.thumbnails   # cached thumbnails
- /.mozilla      # Profiles
- /.dvdcss       # libdvd css cache
- /.local        # local data
- /.hplip        # HPLIP user preferences and session data
- /.fltk         # FLTK preferences and session data
# Session specific files
- /.ICEauthority
- /.Xauthority
- /.esd_auth
- /.dbus
- /.viminfo
- /.bash_history
- /.lesshst
- /.python_history
- /.wget-hsts
- /.xsession-errors*
# already managed
- /.dotfiles
'''

# - ignore (cache, local data, etc)
# - config (config settings)
# - data (user data files)
# - unknown

def save_yaml(fn, dat):
  with open(fn, 'w') as fp:
    yaml.dump(dat, fp)

def load_yaml(fn):
  with open(fn, 'r') as fp:
    dat = yaml.safe_load(fp)
  return dat

def is_fnexpr(expr):
  for ch in ['?','*','[',']']:
    if expr.find(ch) != -1: return True
  return False

def apply_rules(fpath, fname, rules, bpath):
  for rule in rules['ignore']:
    if rule[0] == '/':
      rule = rule[1:]
      cand = fpath
    else:
      cand = fname
    if is_fnexpr(rule):
      if fnmatch.fnmatch(cand, rule): return True
    else:
      if cand == rule: return True

  if not os.path.islink(bpath + fpath):
    print(fpath)
  return False


def walkdir(basedir,cdir,rules):
  dc = os.listdir(basedir + cdir)
  for de in dc:
    fpath = basedir + cdir + '/' + de
    q = (('/','')[cdir == ''])

    if apply_rules(cdir + q + de, de, rules, basedir):
      continue
    
    if not os.path.islink(fpath) and os.path.isdir(fpath):
      walkdir(basedir, cdir + q + de, rules)

def process_dir(cdir, settings):
  while cdir[-1] == '/':
    cdir = cdir[0:-1]
  cdir += '/'
  rules = yaml.safe_load(yaml_document)
  print(yaml.dump(rules))

  # Read current state
  # Read filters
  walkdir(cdir,'', rules)
  
if __name__ == "__main__":
  import argparse
  cli = argparse.ArgumentParser(
    description='home dir mgr'
  )
  cli.add_argument('dirs', action='store', nargs='*')
  settings = cli.parse_args()

  if len(settings.dirs) == 0:
    settings.dirs = [ os.getenv('HOME') ]

  for cdir in settings.dirs:
    process_dir(cdir, settings)

