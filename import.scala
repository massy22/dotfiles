import com.massy22.util._
import com.massy22.util.io._
import com.massy22.util.net._

import scala.io.Source
import scala.collection.JavaConversions._
import scala.xml._
import scala.xml.parsing.XhtmlParser

// import scala.util.matching.Regex
// import scala.collection.jcl.Conversions._
// import java.util.{List => JList, Map => JMap }
// import java.util.{Calendar,Date }

// // import _root_.com.massy22.interactivehelp.Help._
// //
// type -->[A, B]  = PartialFunction[A, B]

// object FileOut{
  // import java.io.{Writer, OutputStreamWriter, FileOutputStream }

  // def os(fileName:String):Writer =
    // new OutputStreamWriter( new FileOutputStream( fileName ), "UTF-8")

  // def apply( fileName:String, content:String ) = {
    // val o = os( fileName )
    // o.write( content )
    // o.flush
    // o.close
  // }
  // def apply( fileName:String, content:Seq[String] ) = {
    // val o = os( fileName )
    // content.foreach { c => o.write( c + "\n" ) }
    // o.flush
    // o.close
  // }
// }

// class MapOrElseOption[A]( o:Option[A] ){

  // def mapOrElse[B]( default : => B)( f:(A) => B ) = o match {
    // case None => default
    // case Some(x) => f(x)
  // }
// }

// implicit def option2MapOrElseOption[A]( o:Option[A] ) = new MapOrElseOption( o )

// class HtmlNodeSeq( xml:NodeSeq ) {
  // def class_?(className:String ) = xml filter{ e =>
    // styleClass(e).split("\\s").contains(className)
  // }

  // def id_?( id:String ) = xml filter{ e =>
    // (e \ "@id" text) == id
  // }
  // def styleClass( xml:NodeSeq ) = xml \ "@class" text
  // def link( xml:NodeSeq ) = xml \ "@href" text
// }
// implicit def nodeSeq2HtmlNodeSeq( xml:NodeSeq ) = new HtmlNodeSeq( xml )

