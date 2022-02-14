package org.homermultitext

import edu.harvard.chs.cite.CtsUrn
import edu.harvard.chs.f1k.GreekNode
import org.apache.commons.io.FilenameUtils


/** Class for indexing scholia to text they comment on.
*/
class ScholiaIndexer {

    /** Directory containing TEI XML files, named
    * following HMT project conventions.
    */
    File xmlSourceDirectory

    /** Writable directory where composite edition will be created.
    */
    File outputDirectory

    /** Name to use for output file. */
    String indexFileName

    /** CTS URN for version of Iliad indexed. */
    CtsUrn iliadUrn 

    String version 

    /** Namespace object for TEI */
    groovy.xml.Namespace tei = new groovy.xml.Namespace("http://www.tei-c.org/ns/1.0")


    String scholiaUrnBase = "urn:cts:greekLit:tlg5026"

    /** Verbosity level 0-3 of debugging output */
    Integer debug = 0



    /** Constructs an indexer for mapping scholia to Iliadic lines they comment
     * on.
     * @param inputDir Directory with TEI editions of scholia.
     * @param outDir Writable directory for output.
     * @param outFileName Name of resulting delimited text file.
     * @param iliad URN for Iliad version
     * @param versionStr Value for version part of scholia URNs.
     */
    ScholiaIndexer(File inputDir, File outDir, String outFileName, CtsUrn iliad, String versionStr) {
        this.xmlSourceDirectory = inputDir        
        this.outputDirectory = outDir
        this.indexFileName = outFileName
        this.iliadUrn = iliad
        this.version = versionStr
    }



    /** Writes a 
     */
    void writeIndex() {
      File scholiaIndex = new File(outputDirectory, indexFileName)
      xmlSourceDirectory.eachFileMatch(~/.*\.xml/) { srcFile ->
	System.err.println "Indexing scholia in " + srcFile
	try {
	  def fRoot = new XmlParser().parse(srcFile)
	  def groupNode = fRoot[tei.text][tei.group][0]
	  def bk = groupNode.'@n'

	  groupNode[tei.text].each { txt ->
	    String workId = txt.'@n'
	    String bookLevel = "${scholiaUrnBase}.${workId}.${version}:${bk}"
	    if (debug > 0) {System.err.println "Indexing book ${bookLevel}"}
	    
	    txt[tei.body][tei.div].each { schol ->
	      String scholionId = schol.'@n'
	      //System.err.println "\tScholion id is " + scholionId
	      schol[tei.div].each { d ->
		switch (d.'@type') {
		case "ref":
		// values must be valid CTS URNs
		CtsUrn scholUrn
		CtsUrn psgUrn
		try {
		  scholUrn = new CtsUrn("${bookLevel}.${scholionId}")
		} catch (Exception e) {
		  System.err.println "Bad URN value for scholion ${bookLevel}.${scholionId}"
		}



		try {
		  // NS CHANGE THIS:  INSIST ON FULL URN IN SOURCE DOC
		  //psgUrn = new CtsUrn("${iliadUrn}" + d.p[0].text())
		  psgUrn = new CtsUrn(d.p[0].text())
		} catch (Exception e) {
		System.err.println "Bad URN value for Iliad passage ${psgUrn}:" + d.p[0].text() + " (reference in scholion ${scholUrn})"
		System.exit(-1)
		}

                        
			scholiaIndex.append("${scholUrn}\t${psgUrn}\n")
			break


			default :
			break
			}
		      }
		      
                    }

                }
            } catch (Exception e) {
                System.err.println "Could not parse or process ${srcFile}!"
                System.err.println "Exception: ${e}"
            }

        }

    }



    /** Creates a ScholiaIndexer object and indexes scholia to Iliad passages.
     * Expects five arguments: (1) source directory for TEI XML editions of
     * scholia, (2) writable directory for output, (3) name of output file for
     * index, (4) Iliad URN and (5) a version identifier for scholia URNs.
     * Yeah, it's a kludgy mess.
    */
    public static void main(String[] args) 
    throws Exception {

        if (args.size() != 5) {
            System.err.println "usage: ScholiaIndexer SRCDIR OUTPUTDIR OUTFILENAME ILIADURN VERSION "
            System.exit(-1)
        }
        
        File src
        File outputDir 
        CtsUrn iliad

        try {
            src = new File (args[0])
            outputDir = new File(args[1])
            if (! outputDir.exists()) {
                outputDir.mkdir()
            }
        } catch (Exception e) {
            System.err.println "ScholiaIndexer main method: Bad param or params: ${args}"
            throw e
        }

        try {
            iliad = new CtsUrn(args[3])
        } catch (Exception e) {
            System.err.println "ScholiaIndexer main method: Bad param or params: ${args[3]}"
	    System.err.println "All params were: " + args
            throw e
        }

	
        ScholiaIndexer indexer = new ScholiaIndexer(src,outputDir, args[2], iliad, args[4])
        indexer.writeIndex()
    }
    /* end main method */

}
