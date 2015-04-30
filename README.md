[![Build Status](https://secure.travis-ci.org/genome/dgi-db.png?branch=master)](https://travis-ci.org/genome/dgi-db)
[![Code Climate](https://codeclimate.com/github/genome/dgi-db.png)](https://codeclimate.com/github/genome/dgi-db)

### Rails frontend to The Genome Institute's drug gene interaction database.

#### Publicly accessible instance
To use DGIdb please first visit the public instance here: [DGIdb](http://www.dgidb.org/ "DGIdb at WashU")

#### Installation
If you would like to install a local instance of DGIdb to work on the code or maintain a private database, refer to the [INSTALL-OSX](https://github.com/genome/dgi-db/blob/master/INSTALL-OSX "INSTALL-OSX") or [INSTALL-LINUX](https://github.com/genome/dgi-db/blob/master/INSTALL-LINUX "INSTALL-OSX") files for installation instructions. If the public version of DGIdb is missing a datasource that you would like to see added, please [Contact Us](http://dgidb.genome.wustl.edu/contact "Contact Us").

#### Implementation
DGIdb is built in Ruby on Rails with PostgreSQL as the primary data store. Memcached is utilized heavily for caching, as the data is largely static between new source imports. The site is served with Apache and Phusion Passenger on a server running Ubuntu 12.04 LTS (Precise Pangolin). The code itself is divided into two primary components – the web application itself and the libraries that handle the importing and normalization of new sources.

The web application is organized in a fairly traditional Model-View-Controller (MVC) architecture with a couple of notable exceptions. In an effort to keep application logic out of the view templates, presenter objects are utilized to decorate domain models with view logic while still allowing access to the underlying models through delegation. Additionally, most domain logic is pulled out into command and helper classes. This allows for a separation of concerns between the persistence layer (data model) and business logic of the application. This architecture also makes the API implementation simpler. The same back-end code runs to produce the result for both the API and the web site. At render time, the result is simply wrapped in a different presenter object and sent to a JSON template instead of an HTML template.

Two of the web application’s primary pieces of functionality are its gene name matching algorithm and its implementation of filtering. The gene name matching process attempts to account for potential ambiguity in user search terms. It first attempts to make an exact match on Entrez gene symbols. If it finds such a match, it assumes it to be what the user meant. If it is unable to find an exact Entrez match for a search term, it reverts to searching through all reported aliases for gene clusters in the system. If the system finds more than one gene cluster that matches the search term, it will classify the result as ambiguous and return all potential gene group matches.  The ambiguity is expressed in both the user interface and API responses in order to help the user decide which gene they meant.

#### Application Programming Interface (API)
The DGIdb API can be used to query for drug-gene interactions in your own applications through a simple JSON based interface.  Extensive documentation of the API including functioning code example is maintained at: http://dgidb.genome.wustl.edu/api

#### Citation
DGIdb - mining the druggable genome. Malachi Griffith\*, Obi L Griffith\*, Adam C Coffman, James V Weible, Josh F McMichael, Nicholas C Spies, 
James Koval, Indraniel Das, Matthew B Callaway, James M Eldred, Christopher A Miller, Janakiraman Subramanian, Ramaswamy Govindan, Runjun D Kumar, 
Ron Bose, Li Ding, Jason R Walker, David E Larson, David J Dooling, Scott M Smith, Timothy J Ley, Elaine R Mardis, Richard K Wilson. 
<a href="http://www.nature.com/nmeth/journal/vaop/ncurrent/full/nmeth.2689.html">Nature Methods</a> (2013) doi:10.1038/nmeth.2689. 
\*These authors contributed equally to this work.

#### License

Copyright (C) 2013 The Genome Institute at Washington University

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see [http://www.gnu.org/licenses/].
