[![Build Status](https://secure.travis-ci.org/genome/dgi-db.png?branch=master)](https://travis-ci.org/genome/dgi-db)
[![Code Climate](https://codeclimate.com/github/genome/dgi-db.png)](https://codeclimate.com/github/genome/dgi-db)

# Rails frontend to The Genome Institute's drug gene interaction database.

## Installation
See the INSTALL-OSX or INSTALL-LINUX files for installation instructions.

## Implementation
DGIdb is built in Ruby on Rails with PostgreSQL as the primary data store. Memcached is utilized heavily for caching, as the data is largely static between new source imports. The site is served with Apache and Phusion Passenger on a server running Ubuntu 12.04 LTS (Precise Pangolin). The code itself is divided into two primary components – the web application itself and the libraries that handle the importing and normalization of new sources.

The web application is organized in a fairly traditional Model-View-Controller (MVC) architecture with a couple of notable exceptions. In an effort to keep application logic out of the view templates, presenter objects are utilized to decorate domain models with view logic while still allowing access to the underlying models through delegation. Additionally, most domain logic is pulled out into command and helper classes. This allows for a separation of concerns between the persistence layer (data model) and business logic of the application. This architecture also makes the API implementation simpler. The same back-end code runs to produce the result for both the API and the web site. At render time, the result is simply wrapped in a different presenter object and sent to a JSON template instead of an HTML template.

Two of the web application’s primary pieces of functionality are its gene name matching algorithm and its implementation of filtering. The gene name matching process attempts to account for potential ambiguity in user search terms. It first attempts to make an exact match on Entrez gene symbols. If it finds such a match, it assumes it to be what the user meant. If it is unable to find an exact Entrez match for a search term, it reverts to searching through all reported aliases for gene clusters in the system. If the system finds more than one gene cluster that matches the search term, it will classify the result as ambiguous and return all potential gene group matches.  The ambiguity is expressed in both the user interface and API responses in order to help the user decide which gene they meant.

Rather than being implemented as SQL WHERE clauses, result filtering is implemented using sets. For interaction filtering, the set of all interactions meeting each possible filter criterion is pre-calculated into a set of ids. Each of these sets can be individually cached for fast retrieval later. Set operations are then utilized to combine filters quickly. For instance, if a user wanted to see only inhibitor interactions that involved kinase genes and are from DrugBank, the following steps would take place. The set of all inhibitor interactions would be intersected with the set of all interactions involving kinases, which would then be intersected with the set of all interactions reported by DrugBank. Each intermediate step as well as the final filter will be cached. Over time, the most common permutations are calculated and cached, making filtering almost instantaneous. Once the final set is calculated, each returned interaction’s id can be checked for presence in the set in constant (O(1)) time.

## Application Programming Interface (API)
The DGIdb API can be used to query for drug-gene interactions in your own applications through a simple JSON based interface.  Extensive documentation of the API including functioning code example is maintained at: http://dgidb.genome.wustl.edu/api

Additional documentation forthcoming...

