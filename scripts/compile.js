import pages from "../pages.json" assert { type: "json" };
import fs from "fs";
import { execSync } from "child_process";

for (const page of pages) {
  const srcPath = `./src/${page.path}.typ`;

  const htmlPath = `./page/${page.path}.html`;
  const pdfPath = `./page/${page.path}.pdf`;

  const htmlCmd = `typst compile ${srcPath} --root . --format html --features html --input fmt=html ${htmlPath}`;
  const pdfCmd = `typst compile ${srcPath} --root . --format pdf --features html --input fmt=pdf ${pdfPath}`;

  execSync(htmlCmd);

  if (page.pdf) {
    execSync(pdfCmd);
  }

  console.log(`Compiled ${srcPath} to ${htmlPath}`);

  if (page.pdf) {
    console.log(`Compiled ${srcPath} to ${pdfPath}`);
  }
}
