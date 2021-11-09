[![Build Status](https://github.com/griffthlab/dgi-db/workflows/Unit%20Tests/badge.svg)](https://github.com/griffithlab/dgi-db/actions)
[![Code Climate](https://codeclimate.com/github/genome/dgi-db.png)](https://codeclimate.com/github/genome/dgi-db)

### Rails frontend to the Drug-Gene Interaction database.

#### Publicly accessible instance
To use DGIdb please first visit the public instance here: [DGIdb](http://www.dgidb.org/ "DGIdb at WashU")

#### Installation
If you would like to install a local instance of DGIdb to work on the code or maintain a private database, refer to the [INSTALL-OSX](https://github.com/genome/dgi-db/blob/master/INSTALL-OSX "INSTALL-OSX") or [INSTALL-LINUX](https://github.com/genome/dgi-db/blob/master/INSTALL-LINUX "INSTALL-OSX") files for installation instructions. Additional installation and developer documentation can be found in the [dgi-db wiki](https://github.com/griffithlab/dgi-db/wiki "dgi-db wiki"). If the public version of DGIdb is missing a datasource that you would like to see added, please [Contact Us](http://dgidb.org/contact "Contact Us").

#### Implementation
DGIdb is built in Ruby on Rails with PostgreSQL as the primary data store. Memcached is utilized heavily for caching, as the data is largely static between new source imports. The site is served with Apache and Phusion Passenger on a server running Ubuntu 12.04 LTS (Precise Pangolin). The code itself is divided into two primary components – the web application itself and the libraries that handle the importing and normalization of new sources.

The web application is organized in a fairly traditional Model-View-Controller (MVC) architecture with a couple of notable exceptions. In an effort to keep application logic out of the view templates, presenter objects are utilized to decorate domain models with view logic while still allowing access to the underlying models through delegation. Additionally, most domain logic is pulled out into command and helper classes. This allows for a separation of concerns between the persistence layer (data model) and business logic of the application. This architecture also makes the API implementation simpler. The same back-end code runs to produce the result for both the API and the web site. At render time, the result is simply wrapped in a different presenter object and sent to a JSON template instead of an HTML template.

Two of the web application’s primary pieces of functionality are its gene name matching algorithm and its implementation of filtering. The gene name matching process attempts to account for potential ambiguity in user search terms. It first attempts to make an exact match on Entrez gene symbols. If it finds such a match, it assumes it to be what the user meant. If it is unable to find an exact Entrez match for a search term, it reverts to searching through all reported aliases for gene clusters in the system. If the system finds more than one gene cluster that matches the search term, it will classify the result as ambiguous and return all potential gene group matches.  The ambiguity is expressed in both the user interface and API responses in order to help the user decide which gene they meant.

#### Application Programming Interface (API)
The DGIdb API can be used to query for drug-gene interactions in your own applications through a simple JSON based interface.  Extensive documentation of the API including functioning code example is maintained at: http://dgidb.org/api

#### Citations
<strong>DGIdb 3.0: a redesign and expansion of the drug-gene interaction database. </strong>Kelsy C Cotto*, Alex H Wagner*, Yang-Yang Feng, Susanna Kiwala, Adam C Coffman,
Gregory Spies, Alex Wollam, Nicholas C Spies, Obi L Griffith, Malachi Griffith. <i>Nucleic Acids Research.</i> 2017 Nov 16. doi:  https://doi.org/10.1093/nar/gkx1143 . *These authors contributed equally to this work. 

<strong>DGIdb 2.0: mining clinically relevant drug-gene interactions.</strong>Alex H Wagner, Adam C Coffman, Benjamin J Ainscough, Nicholas C Spies, Zachary L Skidmore, Katie M Campbell, Kilannin Krysiak, Deng Pan, Joshua F McMichael, James M Eldred, Jason R Walker, Richard K Wilson, Elaine R Mardis, Malachi Griffith, Obi L Griffith. <i>Nucleic Acids Research</i>. 2016 Jan 4;44(D1):D1036-44. doi: <a href="https://doi.org/10.1093/nar/gkv1165">10.1093/nar/gkv1165</a>. PMID: <a href="https://www.ncbi.nlm.nih.gov/pubmed/26531824">26531824</a>.

<strong>DGIdb - mining the druggable genome.</strong>Malachi Griffith\*, Obi L Griffith\*, Adam C Coffman, James V Weible, Josh F McMichael, Nicholas C Spies, 
James Koval, Indraniel Das, Matthew B Callaway, James M Eldred, Christopher A Miller, Janakiraman Subramanian, Ramaswamy Govindan, Runjun D Kumar, 
Ron Bose, Li Ding, Jason R Walker, David E Larson, David J Dooling, Scott M Smith, Timothy J Ley, Elaine R Mardis, Richard K Wilson. <i>Nature Methods</i>. 2013 Dec;10(12):1209-10. doi: <a href="https://doi.org/10.1038/nmeth.2689">10.1038/nmeth.2689</a>. PMID: <a href="https://www.ncbi.nlm.nih.gov/pubmed/24122041">24122041</a>.
\*These authors contributed equally to this work.

#### License
Copyright (c) 2017 The Griffith Lab [www.griffithlab.com]


Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
