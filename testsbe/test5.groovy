@groovy.transform.BaseScript com.ibm.dbb.groovy.ScriptLoader baseScript
//compile and link db2
//with properties file  
//with copies in syslib

import com.ibm.dbb.repository.*
import com.ibm.dbb.dependency.*
import com.ibm.dbb.build.*
import com.ibm.dbb.build.report.*
import com.ibm.dbb.build.html.*
import com.ibm.dbb.build.report.records.*
import groovy.util.*
import groovy.transform.*
import groovy.time.*
import groovy.xml.*


@Field BuildProperties props = BuildProperties.getInstance()

// load build.properties
def buildConf = "/u/adcde/dbb-zappbuild/scripts/testsbe/"
props.load(new File("${buildConf}/properties/test5.properties"))


println("Copying source from zFS to PDS . . .")
def copy = new CopyToPDS().file(new File("${props.fileName}")).dataset("${props.dsn}").member("${props.member}")
copy.execute()

println("Compiling . . .")

def compile = new MVSExec().pgm("${props.compilePgm}").parm("${props.compileOptsdb2}")
compile.dd(new DDStatement().name("SYSIN").dsn("${props.dsn}(${props.member})").options("shr"))
compile.dd(new DDStatement().name("SYSLIN").dsn("&&LOADSET").options("cyl space(1,2) unit(vio) new").pass(true))
compile.dd(new DDStatement().name("SYSUT1").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT2").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT3").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT4").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT5").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT6").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT7").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT8").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT9").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT10").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT11").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT12").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT13").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT14").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT15").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT16").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSUT17").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSMDECK").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("TASKLIB").dsn("${props.compilerDsn}").options("shr"))
compile.dd(new DDStatement().dsn("${props.db2sdsnload}").options("shr"))
compile.dd(new DDStatement().name("DBRMLIB").dsn("${props.dbrmDsn}(${props.member})").options("shr"))
compile.dd(new DDStatement().name("SYSLIB").dsn("${props.syslibDsn}").options("shr"))
compile.dd(new DDStatement().name("SYSPRINT").options("cyl space(5,5) unit(vio)  new"))
compile.copy(new CopyToHFS().ddName("SYSPRINT").file(new File("${props.listingName}")))
def rc = compile.execute()


if (rc > 4)
	println("Compile failed!  RC=$rc")
else
	println("Compile successful!  RC=$rc")
	
println("Linking . . .")
def link = new MVSExec().pgm("${props.linkPgm}").parm("${props.linkOpts}")
link.dd(new DDStatement().name("SYSUT1").options("cyl space(5,5) unit(vio) new"))
link.dd(new DDStatement().name("SYSPRINT").options("cyl space(5,5) unit(vio) new"))
link.dd(new DDStatement().name("SYSLMOD").dsn("${props.syslmodDsn}(${props.member})").options("shr"))
link.dd(new DDStatement().name("TASKLIB").dsn("${props.linkerDsn}").options("shr"))
link.dd(new DDStatement().name("SYSLIB").dsn("${props.linksyslibDsn}").options("shr"))
link.dd(new DDStatement().dsn("${props.db2sdsnload}").options("shr"))
link.copy(new CopyToHFS().ddName("SYSPRINT").file(new File("${props.sysprintLinkName}")))
def rclink = link.execute()


if (rclink > 4)
	println("Link failed!  RC=$rclink")
else
	println("Link successful!  RC=$rclink")
	
	