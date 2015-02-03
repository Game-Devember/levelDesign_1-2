using UnityEngine;
using System.Collections;

public class sc : MonoBehaviour {


	
	// Update is called once per frame
	void Update ()
	{
		transform.Rotate (new Vector3 (0,60,0) * Time.deltaTime);
	}
}
