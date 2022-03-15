import com.ibm.dbb.build.*
//compile and link batch       

//xx
println("Copying source from zFS to PDS . . .")
def copy = new CopyToPDS().file(new File("/u/adcde/dbb-zappbuild/scripts/testsbe/cobol/test1.cbl")).dataset("ADCDE.BUILD.COBOL").member("HELLO1")
copy.execute()

println("Compiling . . .")


def compile = new MVSExec().pgm("IGYCRCTL").parm("LIB")
compile.dd(new DDStatement().name("SYSIN").dsn("ADCDE.BUILD.COBOL(HELLO1)").options("shr"))
compile.dd(new DDStatement().name("SYSLIN").dsn("ADCDE.BUILD.OBJ(HELLO1)").options("shr"))
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
compile.dd(new DDStatement().name("TASKLIB").dsn("IGY620.SIGYCOMP").options("shr"))
compile.dd(new DDStatement().name("SYSPRINT").options("cyl space(5,5) unit(vio)  new"))
compile.copy(new CopyToHFS().ddName("SYSPRINT").file(new File("/u/adcde/out/test1.log")))
def rc = compile.execute()

if (rc > 4)
	println("Compile failed!  RC=$rc")
else
	println("Compile successful!  RC=$rc")
	
println("Linking . . .")
def link = new MVSExec().pgm("IEWBLINK").parm("LIST,XREF,LET,MAP,SIZE=(1400K,800K),AMODE=31,RMODE=ANY")
link.dd(new DDStatement().name("SYSUT1").options("cyl space(5,5) unit(vio) new"))
link.dd(new DDStatement().name("SYSLIN").dsn("ADCDE.BUILD.OBJ(HELLO1)").options("shr"))
link.dd(new DDStatement().name("SYSPRINT").options("cyl space(5,5) unit(vio) new"))
link.dd(new DDStatement().name("SYSLMOD").dsn("ADCDE.COB.LOADLIB(HELLO1)").options("shr"))
link.dd(new DDStatement().name("TASKLIB").dsn("SYS1.LINKLIB").options("shr"))
link.dd(new DDStatement().name("SYSLIB").dsn("CEE.SCEELKED").options("shr"))
link.dd(new DDStatement().dsn("DSNC10.SDSNLOAD").options("shr"))
link.copy(new CopyToHFS().ddName("SYSPRINT").file(new File("/u/adcde/out/sysprintlink1.log")))
def rclink = link.execute()


if (rclink > 4)
	println("Link failed!  RC=$rclink")
else
	println("Link successful!  RC=$rclink")
		
	
	
	