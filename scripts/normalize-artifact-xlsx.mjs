import {readFile,writeFile} from 'node:fs/promises';
import JSZip from 'jszip';
for(const file of process.argv.slice(2)){
 const zip=await JSZip.loadAsync(await readFile(file));
 for(const [name,entry] of Object.entries(zip.files))if(name.endsWith('.xml')&&!entry.dir){const xml=await entry.async('string');zip.file(name,xml.replaceAll('<x:','<').replaceAll('</x:','</').replaceAll('xmlns:x=','xmlns='))}
 await writeFile(file,await zip.generateAsync({type:'nodebuffer',compression:'DEFLATE'}));
}
