package scripts.testsbe;

import com.ibm.dbb.build.*

println("Copying source from zFS to PDS . . .")
def copy = new CopyToPDS().file(new File("/u/adcde/dbb-zappbuild/scripts/testsbe/cobol/test1.cbl")).dataset("ADCDE.BUILD.COBOL").member("HELLO1")
copy.execute()


def compile = new MVSExec().pgm("IGYCRCTL").parm("LIB")
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
compile.dd(new DDStatement().name("SYSMDECK").options("cyl space(5,5) unit(vio) new"))
compile.dd(new DDStatement().name("SYSPRINT").options("cyl space(5,5) unit(vio)  new"))
compile.dd(new DDStatement().name("SYSLIB").dsn("ADCDE.BUILD.COBOL").options("shr"))
compile.dd(new DDStatement().name("SYSIN").dsn("ADCDE.BUILD.COBOL(HELLO1)").options("shr"))
compile.dd(new DDStatement().name("SYSLIN").dsn("ADCDE.BUILD.OBJ(HELLO1)").options("shr"))

def rc = compile.execute()

if (rc > 4)
	println("Compile failed!  RC=$rc")
else
	println("Compile successful!  RC=$rc")