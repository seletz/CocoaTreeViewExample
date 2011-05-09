=======================
Cocoa Tree View Example
=======================

:Author:  Stefan Eletzhofer
:Date:    2011-05-09
:Version: 0.3dev


Abstract
========

For a project I'm currently at, I have the requirement to view heirachical
data in **one** UITableView.

This is what I've come up with, it's a proof-of-concept and badly needs
refactoring.

Features
========

- collapsable/expandable UITableViewCells
- NSMutableDictionary as data model
- no hacks

Data Model
==========

All the specific tree/list handling stuff is done in `TreeListModel`.  This
class offers accessor methods which make it fairly simple to use it as a
`UITableViewDataSource`.

Demo data is load from a JSON file which looks like this.  You get the
idea ;)

::

    {
        "key": "root", 
        "isOpen": true, 
        "value": [
            {
                "isOpen": true, 
                "key": "Chapter 1", 
                "value": [
                    {
                        "isOpen": false, 
                        "key": "Subchapter 1.1", 
                        "value": []
                    }, 
                    {
                        "isOpen": true, 
                        "key": "Subchapter 1.2", 
                        "value": [
                            {
                                "isOpen": false, 
                                "key": "Sub Sub Chapter 1.2.1", 
                                "value": []
                            }, 
                            {
                                "isOpen": false, 
                                "key": "Sub Sub Chapter 1.2.2", 
                                "value": []
                            }, 
                            {
                                "isOpen": false, 
                                "key": "Sub Sub Chapter 1.2.3", 
                                "value": []
                            }
                        ]
                    }, 
                    {
                        "isOpen": false, 
                        "key": "Subchapter 1.3", 
                        "value": []
                    }
                ]
            }, 
            {
                "isOpen": false, 
                "key": "Chapter 2", 
                "value": [
                    {
                        "isOpen": false, 
                        "key": "Subchapter 2.1", 
                        "value": []
                    }, 
                    {
                        "isOpen": false, 
                        "key": "Subchapter 2.2", 
                        "value": []
                    }, 
                    {
                        "isOpen": false, 
                        "key": "Subchapter 2.3", 
                        "value": []
                    }
                ]
            }, 
            {
                "isOpen": true, 
                "key": "Chapter 3", 
                "value": [
                    {
                        "isOpen": false, 
                        "key": "Subchapter 3.1", 
                        "value": []
                    }, 
                    {
                        "isOpen": false, 
                        "key": "Subchapter 3.2", 
                        "value": []
                    }, 
                    {
                        "isOpen": false, 
                        "key": "Subchapter 3.3", 
                        "value": []
                    }
                ]
            }
        ]
    }

Changelog
=========

0.3 - unreleased
----------------

- upgrade JSON data model to multivalued data.
- made a universal app.
- use KVC to access model items.  Remove NSMutableDictionary
  dependency.

0.2 - 2011-05-09
----------------

- refactored, created `TreeListModel`.

0.1 - 2011-05-06
----------------

- Initial release to github

..  vim: set ft=rst tw=75 nocin nosi ai sw=4 ts=4 expandtab:
