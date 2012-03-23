
Sensis SAPI Cocoa SDK ![SAPI Logo](http://img.tweetimag.es/i/sensisapi_b) ![Yellow Pages Logo](http://developers.sensis.com.au/files/yp-api-poweredby-sticky-71x78.png)
=====================

The Sensis API (SAPI) gives you access to Australian local business listings from Yellow Pages and White Pages.

SAPI is implemented using a REST HTTP style and this project provides an easy to use Cocoa interface.

<div style="clear:both;"></div>

Synopsis
========

```objective-c
#import "SAPI.h"
#import "SAPISearch.h"

[SAPI setKey:@"your_sapi_application_key"];
[SAPI setEnvironment:SAPIEnvironmentTest];

SAPISearch * searchQuery = [[SAPISearch alloc] init];
searchQuery.query = @"Apple";
	
[searchQuery performQueryAsyncSuccess:^(SAPISearchResult *result) {

	NSLog(@"Page 1 of %d results: %@", result.totalPages, result.results);

} failure:^(SAPIError *error) {

	NSLog(@"Error fetching results: %@", [error localizedDescription]);

}];
```

See the [Classes](#classes) section below for information about the other endpoints  SAPIGetListingById, SAPIReport and SAPIMetadata.

Table of Contents
=================

<ul>
<li style="margin-top: 0px;">
[Adding the SAPI SDK to your project](#adding)
</li>
 * [Adding AFNetworking](#afnetworking)
 * [JSON Library](#json)
<li style="margin-top: 0px;"> [Getting a SAPI Application Key](#key)
<li style="margin-top: 0px;"> [Running the Unit Tests and Sample App](#sample)
<li style="margin-top: 0px;"> [Classes](#classes)
 * [SAPI](#sapi)
 * [SAPIError](#sapierror)
 * [Request Classes](#requestclasses)
  * [SAPISearch](#sapisearch)
  * [SAPIGetListingById](#sapigetlistingbyid)
  * [SAPIMetadata](#sapimetadata)
  * [SAPIReport](#sapireport)
 * [Result Classes](#resultclasses)
  * [SAPISearchResult](#sapisearchresult)
  * [SAPIMetadataResult](#sapimetadataresult)
  * [SAPIReportResult](#sapireportresult)
<li style="margin-top: 0px;"> [Requirements](#requirements)
<li style="margin-top: 0px;"> [Bugs &amp; Enhancements](#bugs)
<li style="margin-top: 0px;"> [Brought to you by Sensis and Pumptheory](#credits)
</ul>

Adding the SAPI SDK to your project<a name="adding"/>
===================================

All you really need to do is add all the`.m` and `.h` files in the `Sensis SAPI` subfolder (ie. <https://github.com/pumptheory/SAPI-Cocoa-SDK/tree/master/Sensis%20SAPI>), and also add the AFNetworking library to your project (see next section).

While you can simply drag and drop the files, we recommend you use git as your source control and add the SAPI SDK as a git submodule. Something like this:

	cd path/to/your/project_root
	mkdir Externals
	git add Externals
	git submodule add git://github.com/pumptheory/SAPI-Cocoa-SDK.git Externals/SAPI-Cocoa-SDK

When you clone your project repository somewhere else, after the `git clone` you also need to:

	git submodule init
	git submodule update

To learn more about git submodules, see <http://help.github.com/submodules/> and <http://book.git-scm.com/5_submodules.html>.

Adding AFNetworking<a name="afnetworking/>
-------------------

The Cocoa SAPI SDK uses AFNetworking under the hood. To avoid linking problems, you need to add AFNetworking to your project yourself. AFNetworking may change of course - the sample app successfully uses AFNetworking as at commit <AFNetworking/AFNetworking@3484605935a6ba68ee6dabe7c69efedb80ee08a7>

AFNetworking is added very much like the SAPI SDK. See [Getting Started with AFNetworking](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking) for suggestions on how you can add AFNetworking to your project.

JSON Library<a name="json"/>
------------

The Cocoa SAPI SDK requires a JSON parsing library. If you are targeting iOS 5 or OSX 10.7 (or higher), the Apple supplied NSJSON* classes will be used automatically with no actions required on your part. If you are targeting iOS 4 or OSX 10.6, you need to add one of the following JSON libraries to your project:

* [JSONKit](https://github.com/johnezang/JSONKit)
* [yajl-objc](https://github.com/gabriel/yajl-objc)
* [SBJson](http://stig.github.com/json-framework/)
* [NXJson](https://github.com/nextive/NextiveJson)

If you have any of these in your project (even if you are targeting iOS5 or OSX 10.7), they will be automatically preferred in the above order. If you have one of the above libraries and yet prefer the SAPI SDK to use the builtin NSJON* classes, you can put this in your code early enough for it to be loaded prior to the first time the SAPI SDK or AFNetworking files are preprocessed (your .pch header is a good candidate):

    #define _AFNETWORKING_PREFER_NSJSONSERIALIZATION_

Getting a SAPI Application Key<a name="key"/>
==============================

For any of the SAPI requests to succeed, you need an API Key for the SAPI test environment. See <http://developers.sensis.com.au/docs/getting_started/Apply_for_an_API_key> for more information and <http://developers.sensis.com.au> to register. Test environment keys are provisioned automatically so apart from clicking a link in the confirmation email there is no waiting. Information on applying for a Production environment key is also at <http://developers.sensis.com.au/>.

Running the Unit Tests and Sample App<a name="sample"/>
=====================================

After you clone the SAPI SDK git repository you need to update the submodules used by the SDK and the sample app and unit tests:

	git clone git://github.com/pumptheory/SAPI-Cocoa-SDK.git
	cd SAPI-Cocoa-SDK
	git submodule init
	git submodule update

You then need to edit `Test iPhone App/SAPITestAccountKey.h` and replace `put_your_sapi_key_here` with a valid SAPI test environment application key (see above).

The one Xcode project contains the sample test app that you can run (⌘-R) and unit tests for each endpoint (⌘-U).

Classes<a name="classes" />
=======

### SAPI<a name="sapi" />

This class has two class methods you use to set the API key and environment

```objective-c
+ (void)setKey:
+ (void)setEnvironment
```

*Header:* [SAPI.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPI.h)

### SAPIError<a name="sapierror" />

A subclass of `NSError` which is set in the case of an error that resulted in you getting no results. You will want to check the error code to eg. differentiate between a server error and rate limiting (in the latter case retrying may work). The relevant codes are detailed in the header file, and you can see examples of checking the code in the unit tests.

**NB:** the SAPI REST interface confuses successful response codes and HTTP codes somewhat which results in a not-quite 1:1 mapping between the integer codes used by Cocoa SDK and REST interface. The best bet is to stick to using the constants described in the header file.

*Header:* [SAPIError.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIError.h)

*Relevant SAPI REST Docs:* See the relevant endpoint docs and [HTTP Status Codes](http://developers.sensis.com.au/docs/reference/HTTP_Status_Codes)

Request Classes<a name="requestclasses" />
---------------

### SAPISearch<a name="sapisearch" />

Implements the SAPI search endpoint.

Create an instance of `SAPISearch`, set properties relevant to your search criteria (at least one of `query` or `location` are required, then perform the query using either the asynchronous or synchronous method:

```objective-c
- (void)performQueryAsyncSuccess:(void (^)(SAPISearchResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock;
- (SAPISearchResult *)performQueryWithError:(SAPIError **)error;
```

*Headers:* [SAPISearch.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPISearch.h) ⇽ [SAPIEndpoint.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIEndpoint.h)

*Relevant SAPI REST Docs:* [Search endpoint](http://developers.sensis.com.au/docs/endpoint_reference/Search)

### SAPIGetListingById<a name="sapigetlistingbyid" />

Implements the SAPI getListingById endpoint.

Create an instance of `SAPIGetListingById`, set the `businessId` property (which you obtained from the `id` key of a search result), then perform the query using either the asynchronous or synchronous method:

```objective-c
- (void)performQueryAsyncSuccess:(void (^)(SAPISearchResult * result))successBlock
                         failure:(void (^)(SAPIError * error))failureBlock;
- (SAPISearchResult *)performQueryWithError:(SAPIError **)error;
```

*Headers:* [SAPIGetListingById.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIGetListingById.h) ⇽ [SAPIEndpoint.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIEndpoint.h)

*Relevant SAPI REST Docs:* [getListingById endpoint](http://developers.sensis.com.au/docs/endpoint_reference/Get_by_Listing_ID)

### SAPIMetadata<a name="sapimetadata" />

Implements the metadata endpoint for obtaining categories or categoryGroups metadata.

*Headers:* [SAPIMetadata.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIMetadata.h) ⇽ [SAPIEndpoint.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIEndpoint.h)

*Relevant SAPI REST Docs:* [metadata endpoint](http://developers.sensis.com.au/docs/endpoint_reference/Metadata)

### SAPIReport<a name="sapireport" />

Implements the reporting endpoint.

*Headers:* [SAPIReport.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIReport.h) ⇽ [SAPIEndpoint.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIEndpoint.h)

*Relevant SAPI REST Docs:* [report endpoint](http://developers.sensis.com.au/docs/endpoint_reference/Report); [Reporting Usage Events](http://developers.sensis.com.au/docs/endpoint_reference/Reporting_Usage_Events)

Result Classes<a name="resultclasses" />
--------------

### SAPISearchResult<a name="sapisearchresult" />

An instance of this is returned, or passed into the success block, in the case of a successful search or getListingById query (in the latter case there will always be only zero or one dictionary in the results array).

The main results are in the `results` property, as an array of dictionaries formatted exactly as the JSON is returned. See the header for information on other properties, and the [Listing Schema](http://developers.sensis.com.au/docs/reference/Listing_Schema) for information on the possible contents of the results array of dictionaries.

*Headers:* [SAPISearchResult.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPISearchResult.h) ⇽ [SAPIResult.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIResult.h)

*Relevant SAPI REST Docs:* [Search endpoint](http://developers.sensis.com.au/docs/endpoint_reference/Search); [Listing Schema](http://developers.sensis.com.au/docs/reference/Listing_Schema)

### SAPIMetadataResult<a name="sapimetadataresult" />

An instance of this is returned, or passed into the success block, in the case of a successful metadata query. Set the `dataType` property to one of `SAPIMetadataCategoriesKey` or `SAPIMetadataCategoryGroupsKey` before executing the query. One of the `categories` or `categoryGroups` array properties are set - depending on which query was performed.

*Headers:* [SAPIMetadataResult.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIMetadataResult.h) ⇽ [SAPIEndpoint.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIEndpoint.h)

*Relevant SAPI REST Docs:* [metadata endpoint](http://developers.sensis.com.au/docs/endpoint_reference/Metadata)

### SAPIReportResult<a name="sapireportresult" />

An instance of this is returned, or passed into the success block, in the case of a successful report query. Different properties are required for different reporting types. See the header and HTTP docs for more info.

*Headers:* [SAPIReportResult.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIReportResult.h) ⇽ [SAPIEndpoint.h](https://github.com/pumptheory/SAPI-Cocoa-SDK/blob/master/Sensis%20SAPI/SAPIEndpoint.h)

*Relevant SAPI REST Docs:* [report endpoint](http://developers.sensis.com.au/docs/endpoint_reference/Report)<br /><br />[Reporting Usage Events](http://developers.sensis.com.au/docs/endpoint_reference/Reporting_Usage_Events)


Requirements<a name="requirements" />
============

Because the SDK (and AFNetworking) rely on blocks, iOS 4, Mac OSX Lion, or higher, are required.

ARC is not used by either the SDK or AFNetworking, so if your project is ARC based you need to use the `-fno-objc-arc` compiler flag for the SAPI SDK and AFNetworking classes. How to do this is discussed in [Getting Started with AFNetworking](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking).


Bugs &amp; Enhancements<a name="bugs" />
===================

Please report any bugs using GitHub Issues and feel free to send GitHub pull requests for bug fixes or enhancements.

Brought to you by Sensis and Pumptheory<a name="credits" />
=======================================

This Cocoa SAPI SDK was developed by [Pumptheory](http://pumptheory.com) for the Sensis SAPI Hackathons. Follow the [@sensisapi](http://twitter.com/sensisapi) Twitter account for information about upcoming hackathons near you.
