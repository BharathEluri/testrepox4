import com.ibm.dbb.build.MVSExec



@Field BuildProperties props = BuildProperties.getInstance()

//CLI=&C1ENVMNT(1,1)
//TYP=&C1TY(4,4)
//IDXTAB=&C1PRGRP(3,2)
//TABBTC='YYYYYYYNNNNNNNNNNNNNNNNN'
//TABDB2='NYNYYNYNNNNYNYNNYNYNNYNY'
//TABXDL='NNNNNYYNNNNNYYNNNYYNNNYY'
//TABCIC='NNNNNNNNNNYYYYNYYYYNYYYY'
//TABLK2='NNNNYNNNNNNNNNNNNNNNNNNN'
//BTC=&@@TABBTC(&@#IDXTAB,1)
//CIC=&@@TABCIC(&@#IDXTAB,1)
//DB2=&@@TABDB2(&@#IDXTAB,1)
//LK2=&@@TABLK2(&@#IDXTAB,1)
//XDL=&@@TABXDL(&@#IDXTAB,1)
//DB2@VERS='VERSION(&C1FOOTPRT(48,16))'

MVSExec sql = createSqlCommand(buildFile, logicalFile, member, logFile)
MVSExec trn = createTrnCommand(buildFile, logicalFile, member, logFile)
MVSExec compile = createCompileCommand(buildFile, logicalFile, member, logFile)
MVSExec lked1 = createLked1Command(buildFile, logicalFile, member, logFile)
MVSExec lked2 = createLked2Command(buildFile, logicalFile, member, logFile)
MVSExec dbrmcopy = createDbrmcopyCommand(buildFile, logicalFile, member, logFile)


def createSqlCommand(buildFile, logicalFile, member, logFile) {

	def sql = new MVSExec().pgm("DSNHPC").parm("${props.DB2OPT}")
	sql.dd(new DDStatement().name("TASKLIB").dsn("${props.DB2EXIT}").options("shr"))
	sql.dd(new DDStatement().dsn("${props.DB2LOAD}").options("shr"))
	sql.dd(new DDStatement().name("SYSPRINT").dsn("&&SQLLIST").options('cyl space(5,5) unit(vio) new').pass(true))
	sql.dd(new DDStatement().name("SYSTERM").options("DUMMY"))
	sql.dd(new DDStatement().name("SYSUT1").options("trk space(15,15) unit(vio) new"))
	sql.dd(new DDStatement().name("SYSUT2").options("trk space(5,5) unit(vio) new"))
	sql.dd(new DDStatement().name("SYSLIB").dsn("${props.DB2DCLG}").options("shr"))
	sql.dd(new DDStatement().name("DBRMLIB").dsn("&&DBRM"("${props.C1ELEMENT}").options("cyl space(1,1,1) unit(work) new recfm(F,B) blksize(80)").pass(true)))
	sql.dd(new DDStatement().name("SYSIN").dsn("&&ELEMOUT").options('shr'))
	sql.dd(new DDStatement().name("SYSCIN").dsn("&&SYSCIN").options('cyl space(5,5) unit(vio) new').pass(true))
}

def RC = 0
if (RC ==0 && ${props.COB3DYN}== "N" && ${props.@DB2} == "Y") {
	sql.execute()
}



def createTrnCommand(buildFile, logicalFile, member, logFile) {
}

def createCompileCommand(buildFile, logicalFile, member, logFile) {
}

def createLked1Command(buildFile, logicalFile, member, logFile) {
}

def createLked2Command(buildFile, logicalFile, member, logFile) {
}

def createDbrmcopyCommand(buildFile, logicalFile, member, logFile) {
}
