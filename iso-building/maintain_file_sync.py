#!/usr/bin/env python

import os
import sys
import urllib2
import re
from HTMLParser import HTMLParser
import requests
import time
import commands

UPSTREAM_URL = "http://192.168.2.56/eayunVirt/appliance/411/"
DEST_DIR = "/data/testing/EayunOS/"
APPLIANCE_NAME = "EayunOS-Engine-Appliance-4.1"

pattern = re.compile(APPLIANCE_NAME + r"[^0-9]*-(\d{8,})" + ".ova.gz")

upstream_releases = {}
local_copies = {}

class Release:
    def __init__(self, release_num, relative_url, footprint):
        self.release_num = release_num
        self.relative_url = relative_url
        self.footprint = footprint

def update_releases_dict(releases_dict, release_info):
    (release_num, relative_url, footprint) = release_info

    if release_num and relative_url:
        if not release_num in releases_dict.keys():
            found_release = Release(release_num, relative_url, None)
            releases_dict[release_num] = found_release
        else:
            releases_dict[release_num].relative_url = relative_url
    elif release_num and footprint:
        if not release_num in releases_dict.keys(): 
            found_release = Release(release_num, None, footprint)
            releases_dict[release_num] = found_release
        else:
            releases_dict[release_num].footprint = footprint

def get_release_info(path):
    release_num = pattern.search(path).group(1)
    relative_url = ''
    footprint = ''

    if path.endswith('ova.gz'):
        relative_url = path
    elif path.endswith('md5'):
        footprint = path
    else:
        print 'bad url, ignore ...'
        release_num = ''

    return (release_num, relative_url, footprint)

class ReleaseParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            for attr in attrs:
                if attr[0] == 'href' and pattern.search(attr[1]):
                    release_info = get_release_info(attr[1])
                    update_releases_dict(upstream_releases, release_info)

def build_local_dict():
    for file_name in os.listdir(DEST_DIR):
        if file_name.startswith(APPLIANCE_NAME) and pattern.search(file_name):
            release_info = get_release_info(file_name)
            update_releases_dict(local_copies, release_info)

def build_upstream_dict():
    upstream_page = urllib2.urlopen(UPSTREAM_URL).read()
    parser = ReleaseParser()
    parser.feed(upstream_page)

def download(release_num):
    # code borrowed from ovirt-node-plugin-hosted-engine
    relative_url = upstream_releases[release_num].relative_url
    upstream_url = UPSTREAM_URL + relative_url
    local_path = DEST_DIR + relative_url

    def _run_download(remote, local):
        with open(local, 'wb') as f:
            started = time.time()
            try:
                r = requests.get(remote, stream=True)
                if r.status_code != 200:
                    print "Cannot downloading %s, HTTP error: %s" % \
                            (remote, str(r.status_code))
                    os.unlink(local)
                    return None

                size = r.headers.get('content-length')
            except requests.exceptions.ConnectionError as e:
                print "Error downloading %s, Connection error: %s" % \
                        (remote, str(e[0]))
                os.unlink(local)
                return None

            downloaded = 0

            def calculate_speed():
                raw = downloaded // (time.time() - started)
                i = 0
                friendly_names = ("B", "KB", "MB", "GB")
                while int(raw / 1024) > 0:
                    raw = raw / 1024
                    i += 1
                return "%0.2f %s/s" % (raw, friendly_names[i])

            for chunk in r.iter_content(1024 * 256):
                downloaded += len(chunk)
                f.write(chunk)

                current = int(100.0 * (float(downloaded) / float(size)))
                speed = calculate_speed()
                sys.stdout.write("\r%s%% downloaded, %s" % (current, speed))
                sys.stdout.flush

            sys.stdout.write("\n")
            sys.stdout.flush
            return "Done"

    ret = _run_download(upstream_url, local_path)
    
    if ret:
        footprint = upstream_releases[release_num].footprint
        if footprint:
            upstream_footprint = UPSTREAM_URL + footprint
            local_footprint = DEST_DIR + footprint
            print "Downloading footprint ", footprint
            ret = _run_download(upstream_footprint, local_footprint)

            if not ret:
                os.unlink(local_path)
            else:
                print "Checking footprint of %s" % relative_url
                saved_dir = os.getcwd()
                os.chdir(DEST_DIR)
                status = commands.getstatusoutput('md5sum -c %s' % local_footprint)[0]
                if status == 0:
                    print "The downloaded %s seems fine." % relative_url
                    os.chdir(saved_dir)
                    return "Done"
                else:
                    print "The downloaded %s does not match the md5sum!" % relative_url
                    os.unlink(local_footprint)
                    os.unlink(local_path)
                    os.chdir(saved_dir)
        else:
            return "Done"

    return None


if __name__ == '__main__':
    build_local_dict()
    build_upstream_dict()

    for release in sorted(upstream_releases.keys())[-3:]:
        if not release in local_copies.keys():
            print "Downloading ", upstream_releases[release].relative_url
            if download(upstream_releases[release].release_num):
                print "Adding to Local copies..."
                local_copies[release] = upstream_releases[release]
            else:
                print "Downloading failed!"
                sys.exit(1)

    if len(local_copies.keys()) > 3:
        for release in sorted(local_copies.keys())[0:-3]:
            relative_url = local_copies[release].relative_url
            footprint = local_copies[release].footprint

            if relative_url:
                print "Removing ", relative_url
                local_path = DEST_DIR + relative_url
                os.unlink(local_path)

            if footprint:
                print "Removing ", footprint
                local_footprint = DEST_DIR + footprint
                os.unlink(local_footprint)
