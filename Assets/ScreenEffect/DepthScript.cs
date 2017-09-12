using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DepthScript : MonoBehaviour {

#region Variables
    public Shader curShader;
    public float depthPower;
    private Material curMaterial;
#endregion

#region Properties
Material material
{
    get
    {
        if (curMaterial == null)
        {
            curMaterial = new Material(curShader);
            curMaterial.hideFlags = HideFlags.HideAndDontSave;
        }
        return curMaterial;
    }
}
#endregion

void Start()
{
    if (!SystemInfo.supportsImageEffects)
    {
        enabled = false;
        return;
    }

    if (!curShader && !curShader.isSupported)
    {
        enabled = false;
    }
}

void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
{
    if (curShader != null)
    {
        material.SetFloat("_DepthPower", depthPower);
        Graphics.Blit(sourceTexture, destTexture, material);
    }
    else
    {
        Graphics.Blit(sourceTexture, destTexture);
    }
}

void Update()
{
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        depthPower = Mathf.Clamp(depthPower, 0.0f, 5.0f);

}

void OnDisable()
{
    if (curMaterial)
    {
        DestroyImmediate(curMaterial);
    }
}
}
