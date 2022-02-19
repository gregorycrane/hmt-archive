

### Binary image model

- There must be a DataModels collection declared:

   #!citecollections
   URN#Description#Labelling property#Ordering property#License
   urn:cite2:cite:datamodels.v1:#CITE data models#urn:cite2:cite:datamodels.v1.label:##Public domain

- Its properties must be declared:

    #!citeproperties
    Property#Label#Type#Authority list
    urn:cite2:cite:datamodels.v1.urn:#Data model#Cite2Urn#
    urn:cite2:cite:datamodels.v1.label:#Label#String#
    urn:cite2:cite:datamodels.v1.description:#Description#String#

- One of the Objects in that collection must be `binaryimg`:

    #!citedata
    urn#label#description
    urn:cite2:cite:datamodels.v1:binaryimg#Binary image model#Model of binary images manipulable by URN reference.  See <TBA>.


- The CiteBinaryImage datamodel must be declared in a statement that names a collection (by URN) implementing the model, names the model (by URN), provides a short label, and offers a description.

    #!datamodels
    Collection#Model#Label#Description
    urn:cite2:hmt:binaryimg.v1:#urn:cite2:cite:datamodels.v1:binaryimg#Citable image model#CITE architecture model of binary images manipulable by URN reference.  See <TBA>.

-  **N.b.** The *implementing collection* here is *not* a collection of images. In this way `urn:cite2:cite:datamodels.v1:binaryimg` is different from `urn:cite2:cite:datamodels.v1:imagemodel`. In the case of `imagemodel`, a CITE collection of object can implement the model by itself, by virtue of having a `caption` property and a `rights` property. `binaryimg` requires *three* collections (see following).

- The *implementing collection*, `urn:cite2:hmt:binaryimg.v1:`, must be declared as a CITE Collection:

    #!citecollections
    URN#Description#Labelling property#Ordering property#License
    urn:cite2:hmt:binaryimg.v1:#Collections of binary images#urn:cite2:hmt:binaryimg.v1.label:##Public domain

- That collection's properties must be declared:

    #!citeproperties
    Property#Label#Type#Authority list
    urn:cite2:hmt:binaryimg.v1.urn:#Binary Image#Cite2Urn#
    urn:cite2:hmt:binaryimg.v1.label:#Label#String#
    urn:cite2:hmt:binaryimg.v1.collection:#Image Collection#Cite2Urn#
    urn:cite2:hmt:binaryimg.v1.protocol:#Protocol#String#iiifApi,localDeepZoom,JPG,iipDeepZoom
    urn:cite2:hmt:binaryimg.v1.path:#Path on Server#String#
    urn:cite2:hmt:binaryimg.v1.url:#Service URN Base#String#
    urn:cite2:hmt:binaryimg.v1.rights:#Rights#String#

- The Objects in that collection implement the `binaryimg` datamodel. That is, they associate a particular collection of images with the datamodel, and provide the necessary information to resolve those image-URNs to binary image data. Here is a single implementation of `binaryimg`:

    #!citedata
    urn#label#collection#protocol#path#url#rights
    urn:cite2:hmt:binaryimg.v1:vaimg_amphoreusIIF#Binary data for images of the Venetus A manuscript. IIIF Files at the University of Houson.#urn:cite2:hmt:vaimg.2017a:#iiifApi#/project/homer/pyramidal/VenA/#http://www.homermultitext.org/iipsrv?#Creative Commons Attribution Share-Alike.

- Here there is an Object: `urn:cite2:hmt:binaryimg.v1:vaimg_amphoreusIIF`. It has a label. It connects Collection `urn:cite2:hmt:vaimg.2017a:` with `binaryimg`. It specifies that `urn:cite2:hmt:vaimg.2017a:` is available using the `iiifApi` protocol. A valid request for this image can be constructed from a CITE URN identifying an object in `urn:cite2:hmt:vaimg.2017a:`, in combination with the `path` and `url` properties; this implementation is therefore specific to an instance of an image server.

    urn:cite2:hmt:binaryimg.v1:vaimg_iipDeepZoom#Binary data for images of the Venetus A manuscript. IIIF Files at the University of Houson. (must add .tif.dzi)#urn:cite2:hmt:vaimg.2017a:#iipDeepZoom#/project/homer/pyramidal/deepzoom/hmt/vaimg/2017a/#http://www.homermultitext.org/iipsrv?DeepZoom=#Creative Commons Attribution Share-Alike.

- This implmenents `binaryimg` with the `iipDeepZoom` protocol, for the same collection of image-objects, using a different `path` and `url`.

- Two more implementations connect `binaryimg` to the `vaimg` collection, one for locally hosted DeepZoom (`.dzi`) files, and one for locally hosted JPGs:

    urn:cite2:hmt:binaryimg.v1:vaimg_localDeepZoom#Binary data for images of the Venetus A manuscript. DeepZoom files#urn:cite2:hmt:vaimg.2017a:#localDeepZoom#/hmt/vaimg/2017a#image_archive#Creative Commons Attribution Share-Alike.

    urn:cite2:hmt:binaryimg.v1:vaimg_localJPG#Binary data for images of the Venetus A manuscript. DeepZoom files#urn:cite2:hmt:vaimg.2017a:#JPG#/hmt/vaimg/2017a/#image_archive#Creative Commons Attribution Share-Alike.

