using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureUpdateBehaviourScript : MonoBehaviour
{
    [SerializeField] CustomRenderTexture _textureSobel;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        _textureSobel.Update(1);
    }
}
