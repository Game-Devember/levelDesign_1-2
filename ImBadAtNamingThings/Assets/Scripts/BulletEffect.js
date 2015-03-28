#pragma strict
var playerHealth=100;

function Start () {
	GetComponent.<Animation>()["death2"].layer = 1;
	GetComponent.<Animation>()["death2"].wrapMode = WrapMode.Once;
}

function Update () {
	if(playerHealth<=0)
	{
		Destroy(gameObject);
	}
}

function TakeDamage()
 {
 	playerHealth-=50;
 }