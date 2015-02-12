private var player : Transform;               // Reference to the player's position.      // Reference to this enemy's health.
private var nav : NavMeshAgent;               // Reference to the nav mesh agent.


function Awake ()
{
    // Set up the references.
    player = GameObject.FindGameObjectWithTag ("Player").transform;
    nav = GetComponent (NavMeshAgent);
}


function Update ()
{
    
        nav.SetDestination (player.position);
   
}