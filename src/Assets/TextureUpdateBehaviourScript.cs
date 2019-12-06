using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureUpdateBehaviourScript : MonoBehaviour
{
    [SerializeField] CustomRenderTexture _textureApproxDist;
    [SerializeField] CustomRenderTexture _Ssed8ApproxDist;
    [SerializeField] CustomRenderTexture _Ssed8ApproxDist5;
    [SerializeField] CustomRenderTexture _Ssed8ApproxDist10;
    [SerializeField] CustomRenderTexture _Ssed8ApproxDist15;
    [SerializeField] CustomRenderTexture _Ssed8ApproxDist30;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        _textureApproxDist.Update(1);
        _Ssed8ApproxDist.Update(1);
        _Ssed8ApproxDist5.Update(1);
        _Ssed8ApproxDist10.Update(1);
        _Ssed8ApproxDist15.Update(1);
        _Ssed8ApproxDist30.Update(1);
    }
}
