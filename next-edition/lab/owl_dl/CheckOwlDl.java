import java.io.File;
import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.*;
import org.semanticweb.owlapi.profiles.*;
import org.semanticweb.owlapi.reasoner.OWLReasoner;
import org.semanticweb.HermiT.Reasoner;

public class CheckOwlDl {
  static final String EX = "https://example.org/";
  static void require(boolean test, String message) {
    if (!test) throw new AssertionError(message);
  }
  static OWLClass cls(OWLDataFactory df, String local) {
    return df.getOWLClass(IRI.create(EX + local));
  }
  static boolean typed(OWLReasoner r, OWLDataFactory df, String person, String type) {
    return r.isEntailed(df.getOWLClassAssertionAxiom(cls(df,type),
      df.getOWLNamedIndividual(IRI.create(EX+person))));
  }
  public static void main(String[] args) throws Exception {
    System.out.println("JAVA="+System.getProperty("java.version"));
    System.out.println("HERMIT="+Reasoner.class.getPackage().getImplementationVersion());
    String[] names={"graduate","contradiction","without-disjointness","without-about"};
    for (String name:names) {
      OWLOntologyManager manager=OWLManager.createOWLOntologyManager();
      OWLOntology ontology=manager.loadOntologyFromOntologyDocument(new File(args[0],name+".rdf"));
      OWLProfileReport profile=new OWL2DLProfile().checkOntology(ontology);
      require(profile.isInProfile(), name+" violates OWL 2 DL: "+profile);
      OWLReasoner reasoner=new Reasoner.ReasonerFactory().createReasoner(ontology);
      try {
        OWLDataFactory df=manager.getOWLDataFactory();
        boolean consistent=reasoner.isConsistent();
        require(consistent!=name.equals("contradiction"),name+" consistency unexpected");
        System.out.println(name+": OWL2DL=true; consistent="+consistent);
        if (name.equals("graduate")) {
          require(typed(reasoner,df,"maya","Graduate"),"Maya must be Graduate");
          require(typed(reasoner,df,"leo","Graduate"),"Leo must be Graduate");
          require(!typed(reasoner,df,"noCompletion","Graduate"),"No completion: Graduate must not be entailed");
          require(reasoner.isSatisfiable(cls(df,"Graduate")),"Graduate should be satisfiable");
          require(reasoner.isEntailed(df.getOWLSubClassOfAxiom(cls(df,"Graduate"),cls(df,"Person"))),"Graduate subclass Person");
          System.out.println("graduate: Maya=true; Leo=true; noCompletion=not-entailed; Graduate-satisfiable=true; Graduate-subclass-Person=true");
        }
        if (name.equals("without-disjointness")) {
          require(typed(reasoner,df,"maya","LearningResource"),"Domain must entail LearningResource");
          System.out.println("without-disjointness: Maya-LearningResource=true");
        }
        if (name.equals("without-about")) {
          require(!typed(reasoner,df,"maya","LearningResource"),"Without about, LearningResource not entailed");
          System.out.println("without-about: Maya-LearningResource=not-entailed");
        }
      } finally { reasoner.dispose(); }
    }
    System.out.println("PASS: OWL 2 DL profiles, Graduate entailments, disjointness contradiction, and controls.");
  }
}
