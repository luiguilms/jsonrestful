//
//  viewControllerBuscar.swift
//  JSONRESTful
//
//  Created by Luigui Lupacca on 28/11/23.
//

import UIKit

class viewControllerBuscar: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tablaPeliculas: UITableView!
    @IBAction func btnBuscar(_ sender: Any) {
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        
        if nombre.isEmpty{
            let ruta = "http://localhost:3000/peliculas/"
            self.cargarPeliculas(ruta: ruta){
                self.tablaPeliculas.reloadData()
            }
        }else{
            cargarPeliculas(ruta: crearURL){
                if self.peliculas.count <= 0{
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se encontraron coincidencias para : \(nombre)", accion: "cancel")
                }else{
                    self.tablaPeliculas.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func btnSalir(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var txtBuscar: UITextField!
    var peliculas = [Peliculas]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPeliculas.delegate = self
        tablaPeliculas.dataSource = self
        
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta){
            self.tablaPeliculas.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    func cargarPeliculas(ruta:String, completed: @escaping () -> ()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(peliculas[indexPath.row].nombre)"
        cell.detailTextLabel?.text = "Genero:\(peliculas[indexPath.row].genero)Duracion:\(peliculas[indexPath.row].duracion)"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func mostrarAlerta(titulo: String, mensaje:String, accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
    


}
